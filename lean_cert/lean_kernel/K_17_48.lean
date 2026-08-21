import Sound
import lean_certs.cert_17_48

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H17_gt_48_kernel : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 48 := by
  exact certValidRoot_sound (k := 17) (d := 48) (c := cert_17_48) (by decide)
