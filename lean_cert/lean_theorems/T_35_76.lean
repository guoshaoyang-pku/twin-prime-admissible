import Sound
import lean_certs.cert_35_76

open CertVerify

theorem H35_gt_76 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 35) (d := 76) (c := cert_35_76) (by native_decide)
