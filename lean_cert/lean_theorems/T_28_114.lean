import Sound
import lean_certs.cert_28_114

open CertVerify

theorem H28_gt_114 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 28) (d := 114) (c := cert_28_114) (by native_decide)
