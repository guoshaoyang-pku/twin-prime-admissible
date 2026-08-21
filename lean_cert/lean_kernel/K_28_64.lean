import Sound
import lean_certs.cert_28_64

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_64_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 28) (d := 64) (c := cert_28_64) (by decide)
