import Sound
import lean_certs.cert_38_128

open CertVerify

theorem H38_gt_128 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 38) (d := 128) (c := cert_38_128) (by native_decide)
