import Sound
import lean_certs.cert_47_102

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_102_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 47) (d := 102) (c := cert_47_102) (by decide)
