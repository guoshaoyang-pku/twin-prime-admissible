import Sound
import lean_certs.cert_12_30

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H12_gt_30_kernel : ¬ ∃ t : List Nat, admissible 12 t = true ∧ diameter t ≤ 30 := by
  exact certValidRoot_sound (k := 12) (d := 30) (c := cert_12_30) (by decide)
