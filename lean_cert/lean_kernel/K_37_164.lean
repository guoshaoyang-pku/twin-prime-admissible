import Sound
import lean_certs.cert_37_164

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H37_gt_164_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 37) (d := 164) (c := cert_37_164) (by decide)
