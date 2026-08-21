import Sound
import lean_certs.cert_26_100

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_100_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 26) (d := 100) (c := cert_26_100) (by decide)
