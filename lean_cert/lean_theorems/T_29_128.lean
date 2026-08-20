import Sound
import lean_certs.cert_29_128

open CertVerify

theorem H29_gt_128 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 29) (d := 128) (c := cert_29_128) (by native_decide)
