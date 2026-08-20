import Sound
import lean_certs.cert_37_128

open CertVerify

theorem H37_gt_128 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 37) (d := 128) (c := cert_37_128) (by native_decide)
