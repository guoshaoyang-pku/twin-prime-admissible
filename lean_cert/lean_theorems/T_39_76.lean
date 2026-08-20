import Sound
import lean_certs.cert_39_76

open CertVerify

theorem H39_gt_76 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 39) (d := 76) (c := cert_39_76) (by native_decide)
