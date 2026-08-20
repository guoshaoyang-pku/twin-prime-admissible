import Sound
import lean_certs.cert_33_76

open CertVerify

theorem H33_gt_76 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 33) (d := 76) (c := cert_33_76) (by native_decide)
