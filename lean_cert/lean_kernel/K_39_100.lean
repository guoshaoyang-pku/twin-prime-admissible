import Sound
import lean_certs.cert_39_100

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_100_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 39) (d := 100) (c := cert_39_100) (by decide)
