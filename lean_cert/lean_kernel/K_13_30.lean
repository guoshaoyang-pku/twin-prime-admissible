import Sound
import lean_certs.cert_13_30

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H13_gt_30_kernel : ¬ ∃ t : List Nat, admissible 13 t = true ∧ diameter t ≤ 30 := by
  exact certValidRoot_sound (k := 13) (d := 30) (c := cert_13_30) (by decide)
