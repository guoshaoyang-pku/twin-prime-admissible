import Sound
import lean_certs.cert_40_178

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H40_gt_178_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 40) (d := 178) (c := cert_40_178) (by decide)
