import Sound
import lean_certs.cert_26_50

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_50_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 50 := by
  exact certValidRoot_sound (k := 26) (d := 50) (c := cert_26_50) (by decide)
