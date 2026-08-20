import Sound
import lean_certs.cert_48_128

open CertVerify

theorem H48_gt_128 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 48) (d := 128) (c := cert_48_128) (by native_decide)
