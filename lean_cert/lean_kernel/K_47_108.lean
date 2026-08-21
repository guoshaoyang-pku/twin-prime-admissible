import Sound
import lean_certs.cert_47_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_108_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 47) (d := 108) (c := cert_47_108) (by decide)
