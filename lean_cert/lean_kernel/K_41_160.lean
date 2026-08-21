import Sound
import lean_certs.cert_41_160

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_160_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 41) (d := 160) (c := cert_41_160) (by decide)
