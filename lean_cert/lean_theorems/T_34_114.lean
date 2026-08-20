import Sound
import lean_certs.cert_34_114

open CertVerify

theorem H34_gt_114 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 34) (d := 114) (c := cert_34_114) (by native_decide)
