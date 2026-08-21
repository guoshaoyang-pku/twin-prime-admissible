import Sound
import lean_certs.cert_10_30

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H10_gt_30_kernel : ¬ ∃ t : List Nat, admissible 10 t = true ∧ diameter t ≤ 30 := by
  exact certValidRoot_sound (k := 10) (d := 30) (c := cert_10_30) (by decide)
