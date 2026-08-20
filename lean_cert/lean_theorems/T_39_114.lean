import Sound
import lean_certs.cert_39_114

open CertVerify

theorem H39_gt_114 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 39) (d := 114) (c := cert_39_114) (by native_decide)
