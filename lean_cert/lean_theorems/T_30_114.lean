import Sound
import lean_certs.cert_30_114

open CertVerify

theorem H30_gt_114 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 30) (d := 114) (c := cert_30_114) (by native_decide)
