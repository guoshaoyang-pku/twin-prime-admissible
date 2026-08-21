import Sound
import lean_certs.cert_25_48

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_48_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 48 := by
  exact certValidRoot_sound (k := 25) (d := 48) (c := cert_25_48) (by decide)
