import Sound
import lean_certs.cert_48_164

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_164_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 48) (d := 164) (c := cert_48_164) (by decide)
