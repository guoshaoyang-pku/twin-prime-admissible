import Sound
import lean_certs.cert_21_76

open CertVerify

theorem H21_gt_76 : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 21) (d := 76) (c := cert_21_76) (by native_decide)
