import Sound
import lean_certs.cert_32_76

open CertVerify

theorem H32_gt_76 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 32) (d := 76) (c := cert_32_76) (by native_decide)
