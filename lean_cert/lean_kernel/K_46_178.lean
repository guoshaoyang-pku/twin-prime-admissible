import Sound
import lean_certs.cert_46_178

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_178_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 46) (d := 178) (c := cert_46_178) (by decide)
