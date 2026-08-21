import Sound
import lean_certs.cert_48_100

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_100_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 48) (d := 100) (c := cert_48_100) (by decide)
