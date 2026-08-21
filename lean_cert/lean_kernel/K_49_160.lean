import Sound
import lean_certs.cert_49_160

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_160_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 49) (d := 160) (c := cert_49_160) (by decide)
