import Sound
import lean_certs.cert_49_236

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H49_gt_236_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 236 := by
  exact certValidRoot_sound (k := 49) (d := 236) (c := cert_49_236) (by decide)
