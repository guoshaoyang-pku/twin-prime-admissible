import Sound
import lean_certs.cert_17_38

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H17_gt_38_kernel : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 38 := by
  exact certValidRoot_sound (k := 17) (d := 38) (c := cert_17_38) (by decide)
