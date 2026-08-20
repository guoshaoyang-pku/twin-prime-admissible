import Sound
import lean_certs.cert_33_128

open CertVerify

theorem H33_gt_128 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 33) (d := 128) (c := cert_33_128) (by native_decide)
