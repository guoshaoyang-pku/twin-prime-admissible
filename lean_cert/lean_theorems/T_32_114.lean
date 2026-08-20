import Sound
import lean_certs.cert_32_114

open CertVerify

theorem H32_gt_114 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 32) (d := 114) (c := cert_32_114) (by native_decide)
