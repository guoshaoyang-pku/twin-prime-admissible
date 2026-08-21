import Sound
import lean_certs.cert_48_160

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_160_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 48) (d := 160) (c := cert_48_160) (by decide)
