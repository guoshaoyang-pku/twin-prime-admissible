import Sound
import lean_certs.cert_49_100

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_100_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 49) (d := 100) (c := cert_49_100) (by decide)
