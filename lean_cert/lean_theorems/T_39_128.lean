import Sound
import lean_certs.cert_39_128

open CertVerify

theorem H39_gt_128 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 39) (d := 128) (c := cert_39_128) (by native_decide)
