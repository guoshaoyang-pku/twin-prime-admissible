import Sound
import lean_certs.cert_36_114

open CertVerify

theorem H36_gt_114 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 36) (d := 114) (c := cert_36_114) (by native_decide)
