import Sound
import lean_certs.cert_27_76

open CertVerify

theorem H27_gt_76 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 27) (d := 76) (c := cert_27_76) (by native_decide)
