import Sound
import lean_certs.cert_23_50

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H23_gt_50_kernel : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 50 := by
  exact certValidRoot_sound (k := 23) (d := 50) (c := cert_23_50) (by decide)
