import Sound
import lean_certs.cert_40_128

open CertVerify

theorem H40_gt_128 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 40) (d := 128) (c := cert_40_128) (by native_decide)
