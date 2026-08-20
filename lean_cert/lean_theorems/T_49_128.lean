import Sound
import lean_certs.cert_49_128

open CertVerify

theorem H49_gt_128 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 49) (d := 128) (c := cert_49_128) (by native_decide)
