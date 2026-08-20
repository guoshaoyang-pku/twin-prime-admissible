import Sound
import lean_certs.cert_35_80

open CertVerify

theorem H35_gt_80 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 35) (d := 80) (c := cert_35_80) (by native_decide)
