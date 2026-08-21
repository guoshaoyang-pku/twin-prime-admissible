import Sound
import lean_certs.cert_5_10

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H5_gt_10_kernel : ¬ ∃ t : List Nat, admissible 5 t = true ∧ diameter t ≤ 10 := by
  exact certValidRoot_sound (k := 5) (d := 10) (c := cert_5_10) (by decide)
