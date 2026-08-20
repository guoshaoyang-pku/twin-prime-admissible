import Sound
import lean_certs.cert_35_114

open CertVerify

theorem H35_gt_114 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 35) (d := 114) (c := cert_35_114) (by native_decide)
