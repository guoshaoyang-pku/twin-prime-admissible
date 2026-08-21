import Sound
import lean_certs.cert_48_206

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_206_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 206 := by
  exact certValidRoot_sound (k := 48) (d := 206) (c := cert_48_206) (by decide)
