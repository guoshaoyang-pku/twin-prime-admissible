import Sound
import lean_certs.cert_49_178

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_178_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 49) (d := 178) (c := cert_49_178) (by decide)
