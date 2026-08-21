import Sound
import lean_certs.cert_47_178

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_178_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 47) (d := 178) (c := cert_47_178) (by decide)
