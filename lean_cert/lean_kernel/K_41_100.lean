import Sound
import lean_certs.cert_41_100

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_100_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 41) (d := 100) (c := cert_41_100) (by decide)
