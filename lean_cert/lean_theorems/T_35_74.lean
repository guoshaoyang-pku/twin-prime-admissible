import Sound
import lean_certs.cert_35_74

open CertVerify

theorem H35_gt_74 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 35) (d := 74) (c := cert_35_74) (by native_decide)
