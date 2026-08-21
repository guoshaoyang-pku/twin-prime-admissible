import Sound
import lean_certs.cert_47_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_114_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 47) (d := 114) (c := cert_47_114) (by decide)
