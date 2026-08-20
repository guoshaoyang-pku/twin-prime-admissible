import Sound
import lean_certs.cert_29_114

open CertVerify

theorem H29_gt_114 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 29) (d := 114) (c := cert_29_114) (by native_decide)
