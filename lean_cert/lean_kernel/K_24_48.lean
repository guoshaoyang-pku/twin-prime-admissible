import Sound
import lean_certs.cert_24_48

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H24_gt_48_kernel : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 48 := by
  exact certValidRoot_sound (k := 24) (d := 48) (c := cert_24_48) (by decide)
