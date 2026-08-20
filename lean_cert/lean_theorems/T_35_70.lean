import Sound
import lean_certs.cert_35_70

open CertVerify

theorem H35_gt_70 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 35) (d := 70) (c := cert_35_70) (by native_decide)
