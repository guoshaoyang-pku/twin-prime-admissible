import Sound
import lean_certs.cert_47_114

open CertVerify

theorem H47_gt_114 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 47) (d := 114) (c := cert_47_114) (by native_decide)
