import Sound
import lean_certs.cert_31_76

open CertVerify

theorem H31_gt_76 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 31) (d := 76) (c := cert_31_76) (by native_decide)
